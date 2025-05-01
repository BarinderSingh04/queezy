import { Request, Response } from 'express';
import path from 'path';
import fs from 'fs';

class UserController {

    public async getAvatarList(req: Request, res: Response) {
        const avatarsDir = path.join(__dirname, '../../', 'public', 'avatars');
        fs.readdir(avatarsDir, (err, files) => {
            if (err) return res.status(500).json({
                status: 0,
                message: 'Failed to read avatars directory',
                error: `${err}`
            });
            const avatarList = files.map((e) => ({
                url: `${req.protocol}://${req.get("host")}/public/avatars/${e}`,
                localPath: `public/avatars/${e}`,
            }));
            res.json({
                status: 1,
                message: "Avatars fetched successfully",
                data: avatarList
            });
        });
    }
}

export default new UserController();
